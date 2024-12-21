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
    C-Wire is a command-line script that sort your electricity distribution system by station type and user type.
    Results are sorted by electric capacity in a `.csv` file.
</p>

## Installation and running

> [!CAUTION]
> C-WIRE is only available on Linux at the moment.

1. Clone the repository :
```
git clone https://github.com/raphael950/C-Wire.git
```

2. Open your terminal where you cloned the repository :

3. Start the software :
```
bash c-wire.sh [ARG1] [ARG2] [ARG3] ([ARG4])
```
where
| Argument | Explanation  |
| :-------- | :------- |
| ARG1 (string)| Data file path |
| ARG2 (string)| Station type (hvb, hva, lv)|
| ARG3 (string)| Consumer type (comp, indiv, all |
| ARG4 (optional) (int)| Filter the results by a specific power plant ID |

> [!WARNING]
> The data file should be in `/input` for C-WIRE to work.

## C-WIRE output

Depending on the combination you choose, a `.CSV` output file will be created in the `/tests` folder. The latter is sorted by ascending electric capacity.
For example, `bash c-wire.sh input/data.dat hvb comp` will output a file named `hvb_comp.csv`.

> [!NOTE]
> Using a power plant ID for `([ARG4])` will add the id after the combination name output.
> For example, `bash c-wire.sh input/data.dat hvb comp 42` will output a file named `hvb_comp_42.csv`.

> [!TIP]
> In the `lv all` case, C-WIRE will output a second file named `lv_all_minmax.csv`.
> The latter contains the 10 LV stations with the most consumption and the 10 LV stations with the least consumption.

## Creators

Made with ❤️ and ⚡ in Cergy-Pontoise, France.

<a href="https://github.com/raphael950/C-Wire/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=raphael950/C-Wire" />
</a>
