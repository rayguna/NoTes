import os
import sqlite3
import pickle
import sys
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

# Database connection (update the path if necessary)
conn = sqlite3.connect('db/test.sqlite3')

def load_data():
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM notes")
    notes = cursor.fetchall()
    return notes

def preprocess_data(notes):
    data = []
    labels = []
    for note in notes:
        data.append(note[2])  # Assuming content is the 3rd column
        labels.append(note[1])  # Assuming title is the 2nd column
    return data, labels

def train_model(data, labels):
    vectorizer = TfidfVectorizer()
    X = vectorizer.fit_transform(data)
    model = LogisticRegression()
    model.fit(X, labels)
    return vectorizer, model

def save_model(vectorizer, model):
    with open('vectorizer.pkl', 'wb') as f:
        pickle.dump(vectorizer, f)
    with open('model.pkl', 'wb') as f:
        pickle.dump(model, f)

def load_model():
    with open('vectorizer.pkl', 'rb') as f:
        vectorizer = pickle.load(f)
    with open('model.pkl', 'rb') as f:
        model = pickle.load(f)
    return vectorizer, model

def answer_question(question, vectorizer, model):
    X = vectorizer.transform([question])
    prediction = model.predict(X)
    return prediction[0]

def main():
    notes = load_data()
    data, labels = preprocess_data(notes)
    vectorizer, model = train_model(data, labels)
    save_model(vectorizer, model)
    
    if len(sys.argv) > 1:
        user_input = str(sys.argv[1])
        vectorizer, model = load_model()
        response = answer_question(user_input, vectorizer, model)
        print(response)
    else:
        print("No input provided.")

if __name__ == '__main__':
    main()
