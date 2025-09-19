from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField
from wtforms.validators import DataRequired, Email, EqualTo, ValidationError
from flask_bcrypt import Bcrypt
from flask import flash

bcrypt = Bcrypt()

from app import db
from app.models import User, Turma, Atividade

class UserForm(FlaskForm):
    nome = StringField('Nome', validators=[DataRequired()])
    sobrenome = StringField('Sobrenome', validators=[DataRequired()])
    email = StringField('E-mail', validators=[DataRequired(), Email()])
    senha = PasswordField('Senha', validators=[DataRequired()])
    confirmacao_senha = PasswordField('Confirme sua senha', validators=[DataRequired(), EqualTo('senha')])
    btnSubmit = SubmitField('Cadastrar')

    def validate_email(self, email):
        user = User.query.filter_by(email=email.data).first()
        if user:
            raise ValidationError("Este e-mail já está cadastrado. Por favor, utilize outro.")


    def save(self):
        senha_hash = bcrypt.generate_password_hash(self.senha.data).decode('utf-8')
        user = User(
            nome=self.nome.data,
            sobrenome=self.sobrenome.data,
            email=self.email.data,
            senha=senha_hash
        )

        db.session.add(user)
        db.session.commit()
        return user


class LoginForm(FlaskForm):
    email = StringField('E-mail', validators=[DataRequired(), Email()])
    senha = PasswordField('Senha', validators=[DataRequired()])
    btnSubmit = SubmitField('Login')

    def login(self):
        user = User.query.filter_by(email=self.email.data).first()
        if user:
            if bcrypt.check_password_hash(user.senha, self.senha.data):
                return user
            else:
                raise Exception('Senha incorreta!')
        else:
            raise Exception('Usuário não encontrado!')


class TurmaForm(FlaskForm):
    nome = StringField('Nome da Turma', validators=[DataRequired()])
    btnSubmit = SubmitField('Enviar')

    def save(self, user_id):
        turma = Turma(nome=self.nome.data, user_id=user_id)
        db.session.add(turma)
        db.session.commit()
        return turma

class AtividadeForm(FlaskForm):
    nome = StringField('Nome', validators=[DataRequired()])
    detalhes = StringField('Detalhes', validators=[DataRequired()])
    btnSubmit = SubmitField('Cadastrar')

    def save(self, user_id, turma_id):
        atividade = Atividade(
            nome=self.nome.data,
            detalhes=self.detalhes.data,
            user_id=user_id,
            turma_id=turma_id
        )

        db.session.add(atividade)
        db.session.commit()
        return atividade
