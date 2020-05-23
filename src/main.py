from src.service_suggestion import CloudSuggester

AUTO_SEMI = False
CUS_MOD = True
IMG_API = False
VID_API = False
SPC_API = False

AUTO_EXPL = 'Classification Regression Clustering'
CUS_EXPL = 'seaborn scipy pandas'
SPC_EXPL = 'spell_check syntax_analysis low_qualty_audio_handling language_recognition'
IMG_EXPL = 'inappropriate_content_detection facial_analysis search_for_similar_images'
VID_EXPL = 'video_translation audio_transcription keyframe_extraction'


def name_printer(filename, head_value):
    print("Suitable {} are: {}".format(filename[filename.find('/') + 1:filename.find('.')].lower(),
                                      " ".join(head_value.name)))


def main():

    if AUTO_SEMI:
        fn = "data/Automated and semi-automated ML services.csv"
        head_value = CloudSuggester(filename=fn).filter_bool_tb(AUTO_EXPL.split()).head()
        name_printer(fn, head_value)

    if CUS_MOD:
        fn = "data/Platforms for custom modeling.csv"
        head_value = CloudSuggester(filename=fn).filter_cmod_tb(CUS_EXPL.split()).head()
        print(head_value)
        # name_printer(fn, head_value)

    if SPC_API:
        fn = "data/Speech  and text processing APIs comparsion.csv"
        head_value = CloudSuggester(filename=fn).filter_spt_tb(SPC_EXPL.split()).head()
        name_printer(fn, head_value)

    if IMG_API:
        fn = "data/Image analysis APIs comparison.csv"
        head_value = CloudSuggester(filename=fn).filter_bool_tb(IMG_EXPL.split()).head()
        name_printer(fn, head_value)

    if VID_API:
        fn = "data/Video analysis APIs comparsion.csv"
        head_value = CloudSuggester(filename=fn).filter_bool_tb(VID_EXPL.split()).head()
        name_printer(fn, head_value)


if __name__ == '__main__':
    main()

