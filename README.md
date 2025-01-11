
# Safezy Flask API

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Deployment](#deployment)
- [Flutter Integration](#flutter-integration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Introduction

**Safezy Flask API** is a backend service built with Flask that leverages a machine learning model to predict disasters from user-uploaded images. It is seamlessly integrated with a Flutter mobile application, allowing users to capture or select images from their devices and receive real-time disaster predictions.

## Features

- **Image Upload**: Users can upload images via the Flutter app.
- **Disaster Prediction**: Utilizes a pre-trained FastAI model to predict the type of disaster depicted in the image.
- **CORS Enabled**: Ensures smooth communication between the frontend Flutter app and the backend Flask API.
- **Easy Deployment**: Designed to be deployed on Render’s free tier with optimized dependencies.

## Folder Structure

```
Safezy_Flask/
├── app.py                # Main Flask application
├── best_model.pkl        # Pre-trained FastAI model for disaster prediction
├── Procfile              # Render deployment configuration
├── requirements.txt      # Python dependencies
└── README.md             # Project documentation
```

## Installation

Follow these steps to set up the project locally.

### 1. Clone the Repository

```bash
git clone https://github.com/avgvcoding/Safezy_Flask.git
cd Safezy_Flask
```

### 2. Set Up Virtual Environment

It's recommended to use a virtual environment to manage dependencies.

**On macOS/Linux:**

```bash
python3 -m venv venv
source venv/bin/activate
```

**On Windows:**

```cmd
python -m venv venv
venv\Scripts\activate
```

### 3. Install Dependencies

Ensure you have the optimized `requirements.txt` in the project root. Then, install the dependencies:

```bash
pip install -r requirements.txt
```

### 4. Verify the Model File

Ensure that `best_model.pkl` is present in the project root. This file is essential for disaster prediction.

*Note:* If the model file is large and not included in the repository, consider downloading it from a secure storage or using Git Large File Storage (Git LFS).

## Usage

Run the Flask application locally to test its functionality.

```bash
python app.py
```

By default, the app runs on `http://127.0.0.1:5000/`.

### API Testing

You can test the API using tools like **Postman** or **cURL**.

**Using cURL:**

```bash
curl -X POST -F 'file=@path_to_your_image.jpg' http://127.0.0.1:5000/api/predict
```

**Expected Response:**

```json
{
  "prediction": "Flood",
  "probability": 0.95
}
```

## API Endpoints

### `POST /api/predict`

**Description:** Predicts the type of disaster depicted in the uploaded image.

**Request:**

- **Content-Type:** `multipart/form-data`
- **Parameters:**
  - `file`: Image file (formats: png, jpg, jpeg, gif, bmp, tiff, webp, heic, heif, jfif)

**Response:**

- **Success (200):**

  ```json
  {
    "prediction": "Flood",
    "probability": 0.95
  }
  ```

- **Error (400 or 500):**

  ```json
  {
    "error": "Error message detailing what went wrong."
  }
  ```

**Example with Postman:**

1. Open Postman and create a new `POST` request.
2. Set the URL to `http://127.0.0.1:5000/api/predict`.
3. In the "Body" tab, select "form-data".
4. Add a key named `file` with type "File" and upload your image.
5. Send the request and observe the response.

## Contributing

Contributions are welcome! Follow these steps to contribute to **Safezy Flask API**:

1. **Fork the Repository**

2. **Create a New Branch**

   ```bash
   git checkout -b feature/YourFeatureName
   ```

3. **Make Changes and Commit**

   ```bash
   git commit -m "Add your message"
   ```

4. **Push to Your Fork**

   ```bash
   git push origin feature/YourFeatureName
   ```

5. **Create a Pull Request**

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any questions or feedback, please reach out:

- **Email:** aviral.ceo.123@gmail.com
- **GitHub:** [avgvcoding](https://github.com/avgvcoding)

---

**Happy Predicting!** 🎉

---
