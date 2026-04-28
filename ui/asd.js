const cont = document.getElementById('cont');
const vehCont = document.getElementById('vehlistcont');
const vehList = document.getElementById('vehlist');
const driveBtn = document.getElementById('drive');
const searchInput = document.getElementById('searchinput');
const garageLabel = document.getElementById('garagelabel');
const colorPicker = document.getElementById('colorpicker');
const pickerCont = document.getElementById('colorpickercont');
const garageIcon = document.getElementById('garageicon');
const closee = document.getElementById('close');
const loader = document.getElementById('loader');
let selected
let vehColor
let vehs = [];
let locales

function setList(list) {
    vehList.innerHTML = '';

    list.forEach(v => {
        const div = document.createElement('div');
        div.className = 'veh';

        if (v.locked) {
            div.style.opacity = '0.4';
            div.style.pointerEvents = 'none';
        }
        div.innerHTML = `
        <i class="lock fa fa-lock" style="${v.locked ? 'display:flex; pointer-events:none' : 'display:none'}"></i>
        <div class="info">
            <div class="vehlabels">
                <span class="vehbrand">${v.brand}</span>
                <span class="vehname">${v.label}</span>
            </div>
        </div>
        <img src="${v.image}">
        `
        div.onclick = () => setActive(div, v)
        if (selected === v) {
            div.classList.add('active');
            driveBtn.style.display = 'block'
        }
        vehList.append(div)
    })
}

function setActive(div, veh) {
    if (selected === veh) {
        div.classList.remove('active');
        setModel(selected.model)
        selected = null;
        driveBtn.style.display = 'none';
        return
    }
    const divs = vehList.querySelectorAll('.veh');
    divs.forEach(d => d.classList.remove('active'));
    div.classList.add('active')
    driveBtn.style.display = 'block';
    selected = veh
    setModel(selected.model)    
    playSound('select.mp3', 0.15)
}

function setModel(model) {
    fetch(`https://${GetParentResourceName()}/setModel`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            model: model,
            color: vehColor
        })
    });
}

function spawnVeh(model) {
    fetch(`https://${GetParentResourceName()}/spawn`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            model: model,
            color: vehColor
        })
    });
    toggleUi(false)
}

function toggleUi(toggle) {
    if (toggle) {
        vehCont.classList.remove('close');
        cont.style.display = 'flex';
        vehCont.classList.add('open');
        vehColor = null;
        colorPicker.value = '#000000';
        searchInput.value = ''
    } else {
        vehCont.classList.remove('open');
        vehCont.classList.add('close');
        driveBtn.style.display = 'none';
        const divs = vehList.querySelectorAll('.veh');
        divs.forEach(d => d.classList.remove('active'));
        selected = null
        fetch(`https://${GetParentResourceName()}/close`);
        loader.style.display = 'none';
        cont.classList.remove('loading');
        setTimeout(() => {
            cont.style.display = 'none';
        }, 600)
    }
}

function playSound(sf, v) {
    const sound = new Audio(`sounds/${sf}`);
    sound.volume = v;
    sound.play();
}

addEventListener('keydown', (k) => {
    if (k.key === 'Escape') {
        toggleUi(false)
    }
})

searchInput.addEventListener('input', () => {
    const vl = searchInput.value.toLowerCase().trim();
    const filt = vehs.filter(v => v.label.toLowerCase().includes(vl) || v.brand.toLowerCase().includes(vl));
    setList(filt)
    playSound('click.mp3', 0.2)
});

let tm

colorPicker.addEventListener('input', () => {
    clearTimeout(tm)
    tm = setTimeout(() => {
        const vl = colorPicker.value;
        fetch(`https://${GetParentResourceName()}/setColor`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({
                color: vl
            })
        });
        vehColor = vl
    }, 250);
});

window.addEventListener('message', (event) => {
    const data = event.data

    if (data.event === 'open') {
        pickerCont.style.display = 'none';
        if (data.chooseColor === true) {
            pickerCont.style.display = 'block';
        }
        garageIcon.className = data.icon || 'fa fa-car'
        toggleUi(true);
        vehs = data.vehicles
        setList(vehs);
        garageLabel.innerText = data.label
    } else if (data.event === 'locales') {
        locales = data.locales
    } else if (data.event === 'loading') {
        if (data.show) {
            loader.style.display = 'flex';
            cont.classList.add('loading');
        } else {
            loader.style.display = 'none';
            cont.classList.remove('loading');
        }
    }
});

window.onload = function() {
    setTimeout(() => {
        driveBtn.innerText = locales.drive;
        closee.innerText = locales.close;
        searchInput.placeholder = locales.search
    }, 1000)
}