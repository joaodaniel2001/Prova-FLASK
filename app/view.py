from app import app, db
from flask import render_template, url_for, request, redirect
from app.forms import *
from flask_login import login_user, logout_user, current_user, login_required
from sqlalchemy import or_

# Página de Login
@app.route ('/', methods=['GET', 'POST'])
def LoginPage ():
    form = LoginForm()
    if form.validate_on_submit():
        user = form.login ()
        login_user(user, remember=True)
        return redirect(url_for('turmas'))
    return render_template ("usuario_login.html", form=form)

# Página de Cadastro
@app.route ('/cadastro', methods=['GET', 'POST'])
def RegisterPage ():
    form = UserForm ()
    if form.validate_on_submit():
        user = form.save()
        login_user(user, remember=True)
        return redirect(url_for('turmas'))
    return render_template ("usuario_cadastro.html", form=form)

# Deslogar
@app.route('/sair/')
@login_required
def logout ():
    logout_user()
    return redirect(url_for('LoginPage'))

# Lista de Turma
@app.route('/turma', methods=['GET', 'POST'])
@login_required
def turmas():
    dados = Turma.query.order_by(Turma.id)
    context = {'dados': dados.all()}
    return render_template("turma_lista.html", context=context)

# Cadastro de Turma
@app.route('/turma/cadastro', methods=['GET', 'POST'])
@login_required
def turmas_cadastro():
    form = TurmaForm()
    if form.validate_on_submit():
        form.save()
        return redirect(url_for('turmas'))
    return render_template("turma_cadastro.html", form=form)

# Excluir Turma
@app.route('/turma/excluir/<int:id>', methods=['POST'])
@login_required
def excluir_turma(id):
    turma = Turma.query.get_or_404(id)
    db.session.delete(turma)
    db.session.commit()
    return redirect(url_for('turmas'))

# Visualizar Atividades
@app.route('/turma/atividade/visualizar/<int:id>', methods=['GET', 'POST'])
@login_required
def visualizar_turma(id):
    atividade = Atividade.query.get_or_404(id)
    turma = Turma.query.get_or_404(id)
    dados = Atividade.query.order_by(Atividade.id)
    context = {'dados': dados.all()}
    return render_template('atividade_visualizacao.html', atividade=atividade, context=context, turma=turma)

# Criar Atividades
@app.route("/turma/atividade/cadastro", methods=["GET", "POST"])
@login_required
def atividade_turma():
    form = AtividadeForm()
    if form.validate_on_submit():
        form.save()
        return redirect(url_for('turmas'))
    return render_template("atividade_cadastro.html", form=form)