#!/usr/bin/env bash

#
#   Variables
#
if [ -d "../../../../naev-artwork" ]; then
   ARTWORK_PATH="../../../../naev-artwork"
else
   ARTWORK_PATH="../../../naev-artwork"
fi


#
#   Copy them all over
#
function copy_over {
   if [ -f "${ARTWORK_PATH}/3D/final/$1.webp" ]; then
      cp "${ARTWORK_PATH}/3D/final/$1.webp" "$2.webp"
   fi
   if [ -f "${ARTWORK_PATH}/3D/final/$1_engine.webp" ]; then
      cp "${ARTWORK_PATH}/3D/final/$1_engine.webp" "$2_engine.webp"
   fi
   if [ -f "${ARTWORK_PATH}/3D/final/$1_comm.webp" ]; then
      cp "${ARTWORK_PATH}/3D/final/$1_comm.webp" "$2_comm.webp"
   fi
   if [ -d "${ARTWORK_PATH}/3D/3d/$1" ]; then
      mkdir -p 3d/"$2"
      cp "${ARTWORK_PATH}/3D/3d/$1"/* 3d/"$2"/
   fi
}

# A few are missing:
# copy_over "??" "brigand/brigand"
# copy_over "??" "demon/demon"
# copy_over "??" "ingenuity/ingenuity"
# copy_over "??" "odium/odium"
# copy_over "??" "vox/vox"

# And 3 models are apparently extra; otherwise things are one-to-one:
copy_over "admonisher" "admonisher/admonisher"
copy_over "admonisher_empire" "admonisher/admonisher_empire"
copy_over "admonisher_pirate" "admonisher/admonisher_pirate"
copy_over "ancestor" "ancestor/ancestor"
copy_over "ancestor_dvaered" "ancestor/ancestor_dvaered"
copy_over "ancestor_pirate" "ancestor/ancestor_pirate"
copy_over "apprehension" "apprehension/apprehension"
copy_over "archimedes" "archimedes/archimedes"
copy_over "arx" "arx/arx"
copy_over "certitude" "certitude/certitude"
copy_over "derivative" "derivative/derivative"
copy_over "divinity" "divinity/divinity"
copy_over "dogma" "dogma/dogma"
copy_over "drone" "drone/drone"
copy_over "fidelity" "fidelity/fidelity"
copy_over "gawain" "gawain/gawain"
copy_over "goddard" "goddard/goddard"
copy_over "goddard_dvaered" "goddard/goddard_dvaered"
copy_over "hawking" "hawking/hawking"
copy_over "hawking_empire" "hawking/hawking_empire"
copy_over "hyena" "hyena/hyena"
copy_over "ira" "ira/ira"
copy_over "kahan" "kahan/kahan"
copy_over "kestrel" "kestrel/kestrel"
copy_over "kestrel_pirate" "kestrel/kestrel_pirate"
copy_over "koala" "koala/koala"
copy_over "lancelot" "lancelot/lancelot"
copy_over "lancelot_empire" "lancelot/lancelot_empire"
copy_over "llama" "llama/llama"
copy_over "marauder" "marauder/marauder"
copy_over "mule" "mule/mule"
copy_over "nyx" "nyx/nyx"
copy_over "pacifier" "pacifier/pacifier"
copy_over "pacifier_empire" "pacifier/pacifier_empire"
copy_over "peacemaker" "peacemaker/peacemaker"
copy_over "perspicacity" "perspicacity/perspicacity"
copy_over "phalanx" "phalanx/phalanx"
copy_over "phalanx_dvaered" "phalanx/phalanx_dvaered"
copy_over "phalanx_pirate" "phalanx/phalanx_pirate"
copy_over "preacher" "preacher/preacher"
copy_over "quicksilver" "quicksilver/quicksilver"
copy_over "reaver" "reaver/reaver"
copy_over "rhino" "rhino/rhino"
copy_over "rhino_pirate" "rhino/rhino_pirate"
copy_over "schroedinger" "schroedinger/schroedinger"
copy_over "scintillation" "scintillation/scintillation"
copy_over "shaman" "shaman/shaman"
copy_over "shark" "shark/shark"
copy_over "shark_empire" "shark/shark_empire"
copy_over "shark_pirate" "shark/shark_pirate"
copy_over "taciturnity" "taciturnity/taciturnity"
copy_over "vendetta" "vendetta/vendetta"
copy_over "vendetta_dvaered" "vendetta/vendetta_dvaered"
copy_over "vendetta_pirate" "vendetta/vendetta_pirate"
copy_over "vigilance" "vigilance/vigilance"
copy_over "vigilance_dvaered" "vigilance/vigilance_dvaered"
copy_over "virtuosity" "virtuosity/virtuosity"
copy_over "watson" "watson/watson"
copy_over "zalek_diablo" "diablo/diablo"
# copy_over "zalek_drone_bomber" "??"
copy_over "zalek_drone_heavy" "drone/drone_heavy"
# copy_over "zalek_drone_light" "??"
# copy_over "zalek_drone_scout" "??"
copy_over "zalek_hephaestus" "hephaestus/hephaestus"
copy_over "zalek_mephisto" "mephisto/mephisto"
copy_over "zalek_sting" "sting/sting"
