let currentElevatorName = null;
window.addEventListener('keydown', function (event) {
    if (event.key === "Escape") {
        const panel = document.getElementById("elevator");
        panel.classList.remove("animate__backInLeft");
        panel.classList.add("animate__animated", "animate__backOutLeft");
        setTimeout(() => {
            panel.style.display = "none";
            fetch(`https://sk_elevator/elevator_cancel`, {
                method: "POST"
            });
        }, 700);
    }
});
window.addEventListener('message', function (event) {
    const data = event.data;
    const panel = document.getElementById("elevator");
    const buttonGrid = document.getElementById("floorButtons");
    if (data.Action === "open" && Array.isArray(data.PossibleEntrys)) {
        buttonGrid.innerHTML = "";
        currentElevatorName = data.ElevatorName;
        data.PossibleEntrys.forEach(floor => {
            const btn = document.createElement("button");
            btn.className = "floor-button";
            btn.textContent = floor;
            btn.onclick = () => {
                fetch(`https://sk_elevator/number_selected`, {
                    method: "POST",
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        floor: floor,
                        current: data.Current,
                        ElevatorName: currentElevatorName
                    })
                });
                panel.classList.remove("animate__backInLeft");
                panel.classList.add("animate__animated", "animate__backOutLeft");
                setTimeout(() => {
                    panel.style.display = "none";
                }, 700);
            };
            buttonGrid.appendChild(btn);
        });
        panel.classList.remove("animate__backOutLeft");
        panel.classList.add("animate__animated", "animate__backInLeft");
        panel.style.display = "block";
    }
    if (data.Action === "sound") {
        const sound = new Audio(`assets/${data.soundname}`);
        sound.play();
    }
});