ML para o banco de dados de operações cardíacas
================================================

Este é a primeira exploração dos possíveis modelos de ML.
Ele contém um carregador dos dados em `dataset/dbmarcapasso.py` e dois exemplos: `modelos.py` roda cross-validation em vários modelos diferentes e compara os resultados e `decision_tree.py` testa o modelo de árvore de decisão e salva a árvore gerada em um PDF.

O programa espera que exista um arquivo chamado `BDMarcapasso_01jun22.csv` no diretório anterior ao dessa pasta. Esse arquivo foi gerado abrinfo o banco de dados original no LibreOffice e salvando como CSV. O caminho do arquivo CSV pode ser enviado como parâmetro para a função `bdmarcapasso.load_data()`.

A leitura e tratamento dos dados em `bdmarcapasso.py` é bastante simplista. Recomendo trabalhar nisso.

As dependências desse projeto são o pacote [scikit-learn][https://scikit-learn.org/stable/index.html] e [python-graphviz][https://github.com/xflr6/graphviz] para salvar a árvore de decisão em PDF.