async function login() {
    try {
        let obj = {
            nome: document.getElementById("nome").value,
            password: document.getElementById("password").value
        }
        let nurse = await $.ajax({
            url: '/api/nurses/login',
            method: 'post',
            dataType: 'json',
            data: JSON.stringify(obj),
            contentType: 'application/json'
        });
        sessionStorage.setItem("nurseId",nurse.nurse_id);
        window.location = "home.html";


    } catch (err) {
        document.getElementById("msg").innerText = err.responseJSON.msg;
    }
}