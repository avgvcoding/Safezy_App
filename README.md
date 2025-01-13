# Safezy_App

**Safezy_App** is a comprehensive application designed to predict disasters from user-uploaded images. It seamlessly integrates a Flask-based backend API with a Flutter mobile application, providing users with real-time disaster predictions. The machine learning model is trained using the FastAI library, achieving an impressive 95.2% accuracy.

## Table of Contents

- [Demo Video](#demo-video)
- [Introduction](#introduction)
- [Features](#features)
- [Folder Structure](#folder-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Machine Learning Model Training](#machine-learning-model-training)
- [Deployment](#deployment)
- [Flutter Integration](#flutter-integration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Demo Video

Check out the [demo video](https://github.com/avgvcoding/Safezy_App/blob/main/video_20250114_041830_edit.mp4) showcasing the **Safezy_App** in action!

https://github.com/user-attachments/assets/b3be8e15-6421-45e4-b3bc-28dfaa4a8610

## Introduction

**Safezy_App** is a dual-component project that combines a robust backend API with a user-friendly Flutter mobile application. The backend, built with Flask, utilizes a pre-trained FastAI machine learning model to analyze and predict disasters from images uploaded by users. The Flutter app allows users to capture or select images from their devices and receive instant disaster predictions, enhancing safety and preparedness.

## Features

- **Image Upload:** Users can capture images using their device's camera or select images from the gallery.
- **Disaster Prediction:** Utilizes a FastAI-trained model to predict the type of disaster depicted in the image with 95.2% accuracy.
- **Real-Time Feedback:** Provides immediate predictions and probability scores to users.
- **Interactive Map:** Displays sample disaster-prone locations on an interactive map within the app.
- **User-Friendly Interface:** Intuitive design ensuring a seamless user experience.
- **CORS Enabled:** Ensures smooth communication between the Flutter frontend and the Flask backend.
- **Easy Deployment:** Backend is optimized for deployment on Render’s free tier with streamlined dependencies.

## Folder Structure

```
Safezy_App/
├── Colab Notebook/
│   └── Safezy_Notebook.ipynb        # Machine learning model training notebook
├── Flutter_Code/
│   └── (All Flutter code files)      # Flutter mobile application source code
├── app.py                            # Main Flask application
├── best_model.pkl                    # Pre-trained FastAI model for disaster prediction
├── Procfile                          # Render deployment configuration
├── requirements.txt                  # Python dependencies
└── README.md                         # Project documentation
```

## Prerequisites

Before setting up the project, ensure you have the following installed:

- **Python 3.7+**
- **Flutter SDK**
- **Git**
- **Virtual Environment Tool (optional but recommended)**

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/avgvcoding/Safezy_App.git
cd Safezy_App
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

### 3. Install Backend Dependencies

Ensure you have the `requirements.txt` in the project root. Then, install the dependencies:

```bash
pip install -r requirements.txt
```

### 4. Verify the Model File

Ensure that `best_model.pkl` is present in the project root. This file is essential for disaster prediction.

*Note:* If the model file is large and not included in the repository, consider downloading it from a secure storage or using Git Large File Storage (Git LFS).

### 5. Set Up Flutter Application

Navigate to the `Flutter_Code` directory and install dependencies.

```bash
cd Flutter_Code
flutter pub get
```

## Usage

### Running the Flask Backend Locally

To test the backend functionality locally, run:

```bash
python app.py
```

By default, the app runs on `http://127.0.0.1:5000/`.

#### API Testing

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

### Running the Flutter Application

Ensure you have a connected device or emulator, then navigate to the `Flutter_Code` directory and run:

```bash
flutter run
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

## Machine Learning Model Training

The machine learning model used for disaster prediction was trained using the **FastAI** library within a Google Colab notebook. The training achieved an accuracy of **95.2%**, ensuring reliable predictions.

### Training Process

1. **Data Collection:** Collected a diverse dataset of images representing various disaster types.
2. **Data Preprocessing:** Cleaned and augmented the data to improve model robustness.
3. **Model Selection:** Utilized FastAI's pretrained models for transfer learning.
4. **Training:** Fine-tuned the model on the disaster dataset, optimizing for accuracy and generalization.
5. **Evaluation:** Assessed the model's performance, achieving a validation accuracy of 95.2%.
6. **Serialization:** Saved the trained model as `best_model.pkl` for deployment.

### Accessing the Training Notebook

You can view and replicate the training process by accessing the [Safezy_Notebook.ipynb](Colab%20Notebook/Safezy_Notebook.ipynb) located in the `Colab Notebook` directory.

## Deployment

The Flask backend is configured for deployment on **Render's** free tier. Ensure you have a Render account and follow their [deployment guidelines](https://render.com/docs/deploy-flask) to host the application.

### Steps to Deploy

1. **Create a New Web Service:** Choose Flask as the environment.
2. **Connect Repository:** Link your GitHub repository containing the `Safezy_App`.
3. **Configure Build Settings:**
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `gunicorn app:app`
4. **Deploy:** Initiate the deployment process and monitor logs for any issues.

*Note:* Ensure that `best_model.pkl` is accessible to the deployed application, either by including it in the repository or storing it in a secure external storage.

## Flutter Integration

The Flutter application interacts seamlessly with the Flask backend API to provide users with real-time disaster predictions.

### Key Components

- **Image Picker:** Allows users to capture images using the camera or select from the gallery.
- **Prediction Feature:** Sends the selected image to the Flask API and displays the prediction and probability.
- **User Interface:** Designed with a clean and intuitive layout, featuring buttons for camera and gallery access, prediction results, and navigation to other app features like the interactive map.
- **Error Handling:** Provides meaningful error messages to users in case of failed uploads or predictions.

### Directory Overview

All Flutter source code is located within the `Flutter_Code` directory. To explore or modify the Flutter app:

```bash
cd Flutter_Code
```

### Running the Flutter App

Ensure you have Flutter installed and set up on your machine. Then, run:

```bash
flutter run
```

## Contributing

Contributions are welcome! Follow these steps to contribute to **Safezy_App**:

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

Please ensure your contributions adhere to the project’s coding standards and include relevant documentation and tests.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any questions or feedback, please reach out:

- **Email:** aviral.ceo.123@gmail.com
- **GitHub:** [avgvcoding](https://github.com/avgvcoding)

---

**Stay Safe and Prepared with Safezy_App!** 🚀

```
