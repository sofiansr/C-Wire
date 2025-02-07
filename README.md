<h1 align='center'>
  ⚡ C-WIRE ⚡
</h1>

<p align='center'>
  <a>
    <img alt="LINUX" src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black">
    <img alt="C" src="https://img.shields.io/badge/C-00599C?style=for-the-badge&logo=c&logoColor=white">
    <img alt="BASH" src="https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)">  
    <img alt="Licence : MIT" src="https://img.shields.io/badge/License-GPL%20v3-yellow.svg">   
  </a>&nbsp;&nbsp;
</p>

<p align='center'>
    C-Wire is a command-line script that sort your electricity distribution system by station type and user type.<br>
    Results are sorted by electric capacity in a .csv file.
</p>

## Introduction
"C-WIRE" is an assignment given by both Eva ANSERMIN and Romuald GRIGNON, two teachers of mine at CY Tech.<br>
This assignment was due at the end of the first semester of my second year there.<br>
[See the assignment requirements](https://github.com/sofiansr/C-Wire/blob/main/Project%20report%20C-Wire.pdf)
## Installation and running

> [!CAUTION]
> C-WIRE is only available on Linux at the moment.

1. Clone the repository :
```
git clone https://github.com/raphael950/C-Wire.git
```

2. Open your terminal where you cloned the repository :

3. Start C-WIRE :
```
bash c-wire.sh [ARG1] [ARG2] [ARG3] ([ARG4])
```
where
| Argument | Explanation  |
| :-------- | :------- |
| ARG1 (string)| Data file path |
| ARG2 (string)| Station type (hvb, hva, lv)|
| ARG3 (string)| Consumer type (comp, indiv, all) |
| ARG4 (optional) (int)| Filter the results by a specific power plant ID |

> [!WARNING]
> The data file should be in `/input` for C-WIRE to work.

> [!TIP]
> `-h` for any of the arguments will show C-WIRE help.

## C-WIRE output

Depending on the combination you choose, a `.csv` output file will be created at the root. The latter is sorted by ascending electric capacity.

For example, `bash c-wire.sh input/data.dat hvb comp` will output a file named `hvb_comp.csv`.
Old `.csv` files will be moved in the `tests` folder.

> [!NOTE]
> Using a power plant ID for `([ARG4])` will add that ID after the combination name output.
> For example, `bash c-wire.sh input/data.dat hvb comp 42` will output a file named `hvb_comp_42.csv`.

> [!TIP]
> In the `lv all` case (or `lv all ID`), C-WIRE will output a second file named `lv_all_minmax.csv` (or `lv_all_minmax_ID.csv`).
> The latter contains the 10 LV stations with the most consumption and the 10 LV stations with the least consumption.<br>
> The file is sorted by descending electric capacity.

## Creators

Made with ❤️ and ⚡ in Cergy-Pontoise, France.

<a href="https://github.com/raphael950/C-Wire/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=raphael950/C-Wire" />
</a>
