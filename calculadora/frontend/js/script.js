document.getElementById('btngo').onclick = function() {
    const dadosForm = document.getElementById('dados'),
        spinner = document.getElementById('spinner'),
        resultados = document.getElementById('resultados');
    spinner.style.display = 'block';
    fetch('http://localhost:8080/calcula', {
        'method': 'POST',
        'headers': {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        'body': new URLSearchParams(new FormData(dadosForm))
        }).then((response) => response.json())
        .then((data) => {
            document.getElementById('risco-readmissao30').innerHTML = data.readmission_30d;
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

}