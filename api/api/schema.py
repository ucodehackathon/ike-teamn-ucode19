from flask_restplus import fields
from flask_restplus import Model

URL_schema = Model('Movement', {
    '__this': fields.Url(absolute=True),
    'left': fields.String,
    'personId': fields.String,
    'id': fields.String,
})

Original_schema = Model('Original', {
    'url': fields.String,
})

Short_schema = Model('Short', {
    'shorted': fields.String,
})