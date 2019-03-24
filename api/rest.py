from flask import Flask, jsonify
from flask_restful import reqparse, abort, Api, Resource
import process_signals
import boto3
import botocore


app = Flask(__name__)
api = Api(app)

BUCKET_NAME = 'ucode19' # replace with your bucket name
s3 = boto3.resource('s3')
FILE_CSV = 'iketeamn'
FILE_CSV_USER = 'niketeam'


# Todo
# shows a single todo item and lets you delete a todo item
class getData(Resource):
    def get(self, subject, file_name):
        key_pro = "public/football-data/data/Subject-{}/{}.csv".format(subject, file_name)
        key_user = "public/football-data/data/Subject-009/{}.csv".format(file_name)
        try:
            s3.Bucket(BUCKET_NAME).download_file(key_pro, FILE_CSV)
            s3.Bucket(BUCKET_NAME).download_file(key_user, FILE_CSV_USER)
        except botocore.exceptions.ClientError as e:
            if e.response['Error']['Code'] == "404":
               print("The object does not exist.")
            raise
        return process_signals.compare_two_signals(FILE_CSV,FILE_CSV_USER) ,201

api.add_resource(getData, '/getData/<subject>/<file_name>')


if __name__ == '__main__':
     app.run(
        debug=True,
        host="0.0.0.0",
        port=8000)