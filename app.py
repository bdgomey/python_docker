from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')
    
@app.route('/ec2_ssh_lab')
def ec2_ssh_lab():
    return render_template('ec2_ssh_lab.html')

@app.route('/iam_user_lab')
def iam_user_lab():
    return render_template('iam_user_lab.html')

if __name__ == '__main__':
    app.run(debug=True)
    