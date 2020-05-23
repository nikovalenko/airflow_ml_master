import pandas as pd


class CloudSuggester:
    def __init__(self, filename):
        # panda = pd.set_option('display.max_colwidth', -1)
        pd.set_option('display.max_colwidth', None)
        self.tb = pd.read_csv(filename)

    def q_bool_str(self, params):
        cond_str = ''
        for c in range(len(params)):
            add_str = params[c] + "==1"
            cond_str += add_str + ' & ' if c != len(params) - 1 else add_str
        return cond_str

    def q_param_max_str(self, param):
        return '{}=={}'.format(param, self.tb[param].max())

    def filter_bool_tb(self, params):
        return self.tb.query(self.q_bool_str([v.lower() for v in params]))

    def filter_cmod_tb(self, params):
        l_tb = self.tb
        if len(params) == 1:
            if params[0].lower() == 'built_in_algs':
                return l_tb.query(self.q_bool_str(params))
        if len(params) >= 1:
            if 'built_in_algs' in params:
                l_tb = l_tb.query(self.q_bool_str(['built_in_algs']))
            frm_dict = {}
            for v in l_tb.name:
                frm_dict[v.lower()] = [f.lower() for f in
                                       str(l_tb.query('name=="{}"'.format(v)).sup_frameworks).split()[1].split(',')]
            name_dict = {}
            for p in params:
                for k, v in frm_dict.items():
                    if p in v:
                        if k not in name_dict:
                            name_dict[k] = [1]
                        else:
                            name_dict[k].append(1)

            if len(name_dict):
                for k in name_dict:
                    name_dict[k] = len(name_dict[k])
                name_list = [k for k, v in name_dict.items() if v == max(name_dict.values())]
                rows = [l_tb.query('name=="{}"'.format(name_list[n])) for n in range(len(name_list))]
                # pd.set_option('display.max_colwidth', 17)
                return pd.concat(rows) if len(rows) > 1 else rows[0]
            else:
                return l_tb
        else:
            return l_tb

    def filter_spt_tb(self, params):
        q_list = []
        if 'language_recognition' in params:
            q_list.append(self.q_param_max_str('language_recognition'))
            params.remove('language_recognition')
        if 'translation' in params:
            q_list.append(self.q_param_max_str('translation'))
            params.remove('translation')
        true_cols = self.q_bool_str(params)
        if q_list:
            true_cols += ' & ' + ' & '.join(q_list) if true_cols else ' & '.join(q_list)
        return self.tb.query(true_cols)
