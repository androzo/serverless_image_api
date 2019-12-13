from flask import Flask, escape, request, jsonify
from functions import list_image, save_image

app = Flask(__name__)

@app.route('/')
def hello():
    name = request.args.get("name", "World")
    return f'Hello, {escape(name)}!'

@app.route('/save_image', methods=['POST'])
def save_images():
    url = request.args.get("url")
    name = request.args.get("name")
    response = save_image.save_image(url, name)
    return response

@app.route('/list_images')
def list_images():
    response = list_image.list_image()
    return response