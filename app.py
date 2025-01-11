# app.py

from flask import Flask, request, jsonify
from flask_cors import CORS
from fastai.vision.all import load_learner, PILImage
import io
import sys
import pathlib
import os
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Monkey-patch PosixPath to behave like WindowsPath on Windows
if sys.platform.startswith('win'):
    pathlib.PosixPath = pathlib.WindowsPath

# Configure upload folder and allowed extensions
UPLOAD_FOLDER = 'static/uploads/'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'bmp', 'tiff', 'webp', 'heic', 'heif', 'jfif'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Create the upload folder if it doesn't exist
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

MODEL_PATH = 'best_model.pkl'

try:
    print("Loading model...")
    learn = load_learner(MODEL_PATH)
    print("Model loaded successfully.")
except Exception as e:
    print(f"Error loading the model: {e}")

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/api/predict', methods=['POST'])
def predict_api():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request.'}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No file selected for uploading.'}), 400

    if file and allowed_file(file.filename):
        try:
            # Optional: Save the file if you need to keep a record
            # filename = secure_filename(file.filename)
            # file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            # file.save(file_path)

            # Read the image in bytes
            img_bytes = file.read()
            img = PILImage.create(io.BytesIO(img_bytes))

            # Make prediction
            pred, pred_idx, probs = learn.predict(img)

            # Prepare JSON response
            response = {
                'prediction': str(pred),
                'probability': round(float(probs[pred_idx]), 2)  # Percentage format
            }

            return jsonify(response), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    else:
        return jsonify({'error': 'Allowed file types are png, jpg, jpeg, gif, bmp, tiff, webp, heic, heif, jfif.'}), 400

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
