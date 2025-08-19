import os
import pickle
import streamlit as st
from streamlit_option_menu import option_menu

# Page config
st.set_page_config(page_title="Health Assistant",
                   layout="wide",
                   page_icon="🧑‍⚕️")

# Get working directory
working_dir = os.path.dirname(os.path.abspath(__file__))

# Load models safely
def load_model(path):
    try:
        return pickle.load(open(path, 'rb'))
    except Exception as e:
        st.error(f"Error loading model {path}: {e}")
        return None

diabetes_model = load_model(f"{working_dir}/Models/diabetes_model.sav")
heart_disease_model = load_model(f"{working_dir}/Models/heart_disease_model.sav")
parkinsons_model = load_model(f"{working_dir}/Models/parkinsons_model.sav")

# Sidebar navigation
with st.sidebar:
    selected = option_menu("Multiple Disease Prediction System",
                           ["Diabetes Prediction",
                            "Heart Disease Prediction",
                            "Parkinsons Prediction"],
                           menu_icon="hospital-fill",
                           icons=["activity", "heart", "person"],
                           default_index=0)

# Utility: safe float conversion
def safe_float(x):
    try:
        return float(x)
    except:
        return 0.0   # default if empty or invalid

# =================== Diabetes Page ===================
if selected == "Diabetes Prediction":
    st.title("Diabetes Prediction using ML")

    col1, col2, col3 = st.columns(3)
    Pregnancies = col1.text_input("Number of Pregnancies")
    Glucose = col2.text_input("Glucose Level")
    BloodPressure = col3.text_input("Blood Pressure value")

    SkinThickness = col1.text_input("Skin Thickness value")
    Insulin = col2.text_input("Insulin Level")
    BMI = col3.text_input("BMI value")

    DiabetesPedigreeFunction = col1.text_input("Diabetes Pedigree Function value")
    Age = col2.text_input("Age of the Person")

    diab_diagnosis = ""
    if st.button("Diabetes Test Result", key="diabetes_btn"):
        if diabetes_model:
            user_input = [safe_float(x) for x in
                          [Pregnancies, Glucose, BloodPressure, SkinThickness,
                           Insulin, BMI, DiabetesPedigreeFunction, Age]]

            diab_prediction = diabetes_model.predict([user_input])
            diab_diagnosis = "The person is diabetic" if diab_prediction[0] == 1 else "The person is not diabetic"

    st.success(diab_diagnosis)

# =================== Heart Disease Page ===================
if selected == "Heart Disease Prediction":
    st.title("Heart Disease Prediction using ML")

    col1, col2, col3 = st.columns(3)
    age = col1.text_input("Age")
    sex = col2.text_input("Sex")
    cp = col3.text_input("Chest Pain types")

    trestbps = col1.text_input("Resting Blood Pressure")
    chol = col2.text_input("Serum Cholestoral in mg/dl")
    fbs = col3.text_input("Fasting Blood Sugar > 120 mg/dl")

    restecg = col1.text_input("Resting Electrocardiographic results")
    thalach = col2.text_input("Maximum Heart Rate achieved")
    exang = col3.text_input("Exercise Induced Angina")

    oldpeak = col1.text_input("ST depression induced by exercise")
    slope = col2.text_input("Slope of the peak exercise ST segment")
    ca = col3.text_input("Major vessels colored by flourosopy")

    thal = col1.text_input("thal: 0 = normal; 1 = fixed defect; 2 = reversable defect")

    heart_diagnosis = ""
    if st.button("Heart Disease Test Result", key="heart_btn"):
        if heart_disease_model:
            user_input = [safe_float(x) for x in
                          [age, sex, cp, trestbps, chol, fbs, restecg,
                           thalach, exang, oldpeak, slope, ca, thal]]

            heart_prediction = heart_disease_model.predict([user_input])
            heart_diagnosis = "The person is having heart disease" if heart_prediction[0] == 1 else "The person does not have any heart disease"

    st.success(heart_diagnosis)

# =================== Parkinson's Page ===================
if selected == "Parkinsons Prediction":
    st.title("Parkinson's Disease Prediction using ML")

    cols = st.columns(5)
    fields = [
        "MDVP:Fo(Hz)", "MDVP:Fhi(Hz)", "MDVP:Flo(Hz)", "MDVP:Jitter(%)", "MDVP:Jitter(Abs)",
        "MDVP:RAP", "MDVP:PPQ", "Jitter:DDP", "MDVP:Shimmer", "MDVP:Shimmer(dB)",
        "Shimmer:APQ3", "Shimmer:APQ5", "MDVP:APQ", "Shimmer:DDA", "NHR",
        "HNR", "RPDE", "DFA", "spread1", "spread2", "D2", "PPE"
    ]

    inputs = []
    for i, field in enumerate(fields):
        inputs.append(cols[i % 5].text_input(field))

    parkinsons_diagnosis = ""
    if st.button("Parkinson's Test Result", key="parkinsons_btn"):
        if parkinsons_model:
            user_input = [safe_float(x) for x in inputs]
            parkinsons_prediction = parkinsons_model.predict([user_input])
            parkinsons_diagnosis = "The person has Parkinson's disease" if parkinsons_prediction[0] == 1 else "The person does not have Parkinson's disease"

    st.success(parkinsons_diagnosis)
