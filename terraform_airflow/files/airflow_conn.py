from airflow import settings
from airflow.models import Connection
#create a connection object
extra = '{"region_name": "us-east-1"}'
conn_id = 'airflow-sagemaker'
conn = Connection(conn_id=conn_id,conn_type='aws', extra=extra)
# get the session
session = settings.Session()
session.add(conn)
session.commit()

