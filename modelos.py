#!/usr/bin/python
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import cross_val_score
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from dataset import bdmarcapasso

# Lê os dados
data = bdmarcapasso.load_data()
X = data['X']
y = [x+y+z+w for x,y,z,w in zip(data['y_readmission30d'], data['y_readmission60d'], data['y_readmission180d'], data['y_readmission1y'])] # Todas as readmissões
print("Dados lidos com sucesso")

# Normaliza os dados em uma escala de 0 a 1
scaler = StandardScaler()  
X = StandardScaler().fit_transform(X)
print("Dados normalizados")

# Gerar vários classificadores e calcular o score de cada um
names = [
    "Nearest Neighbors",
    "Linear SVM",
    "Decision Tree",
    "Random Forest",
    "RBF SVM",
    "Neural Net",
]
classifiers = [
    KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    SVC(gamma=2, C=1),
    MLPClassifier(max_iter=1000),
]

for name, clf in zip(names, classifiers):
    print("Treinando classificador: " + name)
    scores = cross_val_score(clf, X, y, cv=5) # cv=5 é o número de folds de cross-validation
    print("Acurácia %0.2f com desvio padrão de %0.2f" % (scores.mean(), scores.std()))
    print("")
