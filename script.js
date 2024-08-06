document.getElementById('switch-bar').addEventListener('click', function() {
    this.classList.toggle('active');
    document.getElementById('body').classList.toggle('night-mode');
    const txt = document.getElementsByClassName('switch-txt');
    if (this.classList.contains('active')) {
        const audio = new Audio("audio/night.mp3");
        audio.play();
        txt[0].textContent = 'NIGHT MODE';
    } else {
        const audio = new Audio("audio/day.mp3");
        audio.play();
        txt[0].textContent = 'DAY MODE';
    }
});

document.querySelectorAll('a.smooth-scroll').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

for (let i = 1; i <= 4; i++) {
    let txtElement = document.getElementById(`portfolio-txt_${i}`);
    let boxElement = document.getElementById(`portfolio-box_${i}`);
    let defaultBoxElement = document.getElementsByClassName(`portfolio-box-default`);
    if (txtElement && boxElement) {
        txtElement.addEventListener('mouseover', function() {
            boxElement.style.left = '0%';
            defaultBoxElement[0].style.left = '-100%';
            for (let j = 1; j <= 4; j++) {
                let lastBoxElement = document.getElementById(`portfolio-box_${j}`);
                if (boxElement != lastBoxElement) {
                    lastBoxElement.style.left = '-100%';
                    let iframe = lastBoxElement.querySelector('iframe');
                    if (iframe) {
                        iframe.contentWindow.postMessage( '{"event":"command", "func":"pauseVideo", "args":""}', '*');
                    }
                }
            }
        });
    }
}

document.getElementById('portfolio-title').addEventListener('click', function() {
    for (let i = 1; i <= 4; i++) {
        let Element = document.getElementById(`portfolio-txt_${i}`);
        Element.style.transition = '0s';
        Element.style.left = '150%';
        setTimeout(() => {
            Element.style.transition = '0.3s';
            Element.style.left = '0%';
        }, i*60);
    }
});


