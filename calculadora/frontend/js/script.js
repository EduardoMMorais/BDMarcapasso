document.getElementById('btngo').onclick = function() {
    const dadosForm = document.getElementById('dados'),
        spinner = document.getElementById('spinner'),
        resultados = document.getElementById('resultados');
    spinner.style.display = 'block';
    fetch('marcapasso', {
        'method': 'POST',
        'headers': {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        'body': new URLSearchParams(new FormData(dadosForm))
        }).then((response) => response.json())
        .then((data) => {
            document.getElementById('risco-readmissao30').innerHTML = data.readmission_30d.toLocaleString('pt-BR', {'minimumFractionDigits':2, 'maximumFractionDigits':2});
            document.getElementById('tab-resultados').style.display = 'block';
        }).catch((x) => {
            const errorMessage = document.createElement("div");
            errorMessage.className="error";
            errorMessage.innerText = "Erro ao carregar. Tente novamente mais tarde";
            resultados.appendChild(errorMessage);
            console.log(x);
        }).finally(() => {
            spinner.style.display = 'none';
        });
    document.getElementById('resultados').scrollIntoView();

}
