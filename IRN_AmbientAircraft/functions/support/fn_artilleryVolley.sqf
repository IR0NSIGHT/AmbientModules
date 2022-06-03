/*
    Function that generates artillery fire for x amount of time in this area

*/
params [
    ["_center"],    //posASL pls
    ["_radius"],
    ["_duration"],
    ["_projectile"],
    //Flare_82mm_AMOS_White,Smoke_82mm_AMOS_White,Sh_82mm_AMOS,        Smoke_120mm_AMOS_White
    ["_intensity"],
    ["_logic"]
];

while {_duration > 0} do {
    for "_i" from 0 to _intensity do {
        //get random position uniform across circle
        _length = sqrt(random _radius); //root bc: pi*(sqrt(rand)*r)^2 = pi*rand*r => uniform distribution across circle

        _dir = vectorNormalized [-1 + random 2,-1 + random 2,0];
        _dir = _dir vectorMultiply _length;
        _dir set [2,dir#2+300];    //300m above ground
        _pos = _center vectorAdd _dir;
        //TODO: find appropriate downwards velocity: fast for HE, very slow for flare
        
        //spawn projectile
        _proj = createVehicle["classnamegoeshere",_pos]
    }
    //sleep
    _timeout = 1;
    _duration = _duration - _timeout;
    sleep _timeout;
}