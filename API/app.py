from flask import Flask, render_template, request
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import PassiveAggressiveClassifier
import pickle
import pandas as pd
from sklearn.model_selection import train_test_split

app = Flask(__name__)
tfvect = TfidfVectorizer(stop_words='english', max_df=0.7)
loaded_model = pickle.load(open('model.pkl', 'rb'))

# We need to fit the TFIDF VEctorizer
fake_df = pd.read_csv('Fake.csv')
real_df = pd.read_csv('True.csv')
fake_df.drop(['date', 'subject'], axis=1, inplace=True)
real_df.drop(['date', 'subject'], axis=1, inplace=True)

fake_df['class'] = 0
real_df['class'] = 1


news_df = pd.concat([fake_df, real_df], ignore_index=True, sort=False)
news_df['text'] = news_df['title'] + news_df['text']
news_df.drop('title', axis=1, inplace=True)


features = news_df['text']
targets = news_df['class']


X_train, X_test, y_train, y_test = train_test_split(
    features, targets, test_size=0.20, random_state=18)


def fake_news_det(news):
    tfid_x_train = tfvect.fit_transform(X_train)
    tfid_x_test = tfvect.transform(X_test)
    input_data = [news]
    vectorized_input_data = tfvect.transform(input_data)
    prediction = loaded_model.predict(vectorized_input_data)
    return prediction

# Defining the site route


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/predict', methods=['GET'])
def predict():
    if request.method == 'GET':
        message = request.args['query']
        pred = fake_news_det(message)
        print(pred)
        return str(pred)
    else:
        return render_template('index.html', prediction="Something went wrong")


if __name__ == "__main__":
    app.run(debug=True)
