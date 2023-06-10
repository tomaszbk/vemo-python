import requests
import json
from sqlalchemy import create_engine

engine = create_engine('postgresql://username:password@db:5432/database')

response_API = requests.get('https://restcountries.com/v3.1/all')

data = json.loads(response_API.text)
