var hidden = false;

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        var data = event.data;
        var action = data.action;
        if (action == 'toggle') {
            if (hidden) {
                $('.container').fadeOut();
            } else {
                $('.container').fadeIn();
            }
            hidden = !hidden;
        }

        if (action == 'show') {
            $('.container').fadeIn();
            hidden = true;
        }

        if (action == 'hide') {
            $('.container').fadeOut();
            hidden = false;
        }

        if (action == 'setValue') {
            setValue(data.key, data.value)
        }

        if (action == 'addcash') {
            var element = $("<div class= 'cashchange'><font style='color: rgb(255,255,255); font-weight: 700; margin-right: 6px;'>+ <span id='dollar-plus'>$</span>" + data.value + "</font></div>");
            $("#cashchange").append(element);
            setTimeout(function (){
                $(element).fadeOut(1000, function () {$(this).remove();});
            }, 1000);
        } 

        if (action == 'removeCash') {
            var element = $("<div class= 'cashchange'><font style='color: rgb(255,255,255); font-weight: 700; margin-right: 6px;'>- <span id='dollar-min'>$</span>" + data.value + "</font></div>");
            $("#cashchange").append(element);
            setTimeout(function (){
                $(element).fadeOut(1000, function () {$(this).remove();});
            }, 1000);
        } 


        if (action == 'updateValue') {
            updateValue(data.key, data.value)
        }

    })
})

function setValue(key, value) {
    $('#' + key).html("<span id='dollar'>$</span>" + value)
}

function updateValue(key, value) {
    $('#' + key).html("<span id='dollar'>$</span>" + value)
}