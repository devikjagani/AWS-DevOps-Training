from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    projects = [
        "Flask Blog App",
        "API Security Tool",
        "AWS Infra Automation"
    ]
    return render_template('index.html', name="Devik Jagani", projects=projects)

if __name__ == '__main__':
    app.run(debug=True)
