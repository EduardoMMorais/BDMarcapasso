#!/usr/bin/python
from dataset import bdmarcapasso
from sklearn.model_selection import train_test_split
from sklearn import tree

# Lê os dados
data = bdmarcapasso.load_data()
X = data['X']
y = data['y_readmission30d']
print("Dados lidos com sucesso")

# Separa os dados em treinamento e teste
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3)

# Treina
print("Treinando árvore de decisão")
clf = tree.DecisionTreeClassifier(max_depth=5)
clf.fit(X_train, y_train)

# Calcula o score com os dados de teste
scores = clf.score(X_test, y_test)
print("Acurácia %0.5f" % (scores))
print("")

# Imprime a árvore de decisão em PDF
tree.plot_tree(clf)
import graphviz
dot_data = tree.export_graphviz(clf, out_file=None, feature_names=bdmarcapasso.labels)
graph = graphviz.Source(dot_data) 
graph.render("Marcapasso_DecisionTree") 
