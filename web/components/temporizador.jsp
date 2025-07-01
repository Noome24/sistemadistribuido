<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="timer-container">
    <div class="timer" id="timer">01:00</div>
    <div class="timer-label">Tiempo de inactividad</div>
</div>

<script>
    // Tiempo de inactividad en segundos (definir solo una variable para todo)
    const INACTIVITY_TIME = 30;
    let inactivityTime = INACTIVITY_TIME;
    let timer;

    function resetTimer() {
        clearTimeout(timer);
        inactivityTime = INACTIVITY_TIME;
        updateTimerDisplay();
        startTimer();
    }

    function startTimer() {
        timer = setTimeout(function() {
            if (inactivityTime > 0) {
                inactivityTime--;
                updateTimerDisplay();
                startTimer();
            } else {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        }, 1000);
    }

    function updateTimerDisplay() {
        const minutes = Math.floor(inactivityTime / 60);
        const seconds = inactivityTime % 60;
        document.getElementById('timer').textContent = 
            (minutes < 10 ? '0' + minutes : minutes) + ':' + 
            (seconds < 10 ? '0' + seconds : seconds);
        
        if (inactivityTime < 10) {
            document.getElementById('timer').style.color = '#ff4444';
        } else {
            document.getElementById('timer').style.color = 'white';
        }
    }

    const events = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart'];
    events.forEach(function(name) {
        document.addEventListener(name, resetTimer, true);
    });

    resetTimer();
</script>
