# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

OVERRIDE_GO_VERSIONS = {
    "1.15.14": {
        "darwin_amd64": (
            "go1.15.14.darwin-amd64.tar.gz",
            "86b350467d5a09e717129d107072d242ec1cf9a1511acd46efe4ec825f6fe3dd",
        ),
        "freebsd_386": (
            "go1.15.14.freebsd-386.tar.gz",
            "520bd7eae9af3b769a5f4273f0b8e11951fe0376f179907e76e16bac880aff1b",
        ),
        "freebsd_amd64": (
            "go1.15.14.freebsd-amd64.tar.gz",
            "9ac2f0d4e35cb1275c10c83cb86c4a24374f34682298ca2d6cfff86349d21859",
        ),
        "linux_386": (
            "go1.15.14.linux-386.tar.gz",
            "0216746103b8da20b23f91a86795bcf72e12428b2d07dfd3279a14b070ceaa74",
        ),
        "linux_amd64": (
            "go1.15.14.linux-amd64.tar.gz",
            "6f5410c113b803f437d7a1ee6f8f124100e536cc7361920f7e640fedf7add72d",
        ),
        "linux_arm64": (
            "go1.15.14.linux-arm64.tar.gz",
            "84e483d1ec7dae591f28f218485f8f67877412e24b8cea626bebf25b6d299c7f",
        ),
        "linux_arm": (
            "go1.15.14.linux-armv6l.tar.gz",
            "a40fe975caf82daef311e22902eb4aeda1f0bd63a782c1ebd81911abed6c187b",
        ),
        "linux_ppc64le": (
            "go1.15.14.linux-ppc64le.tar.gz",
            "e17c29518940885d9f4a2e02f63c922d1c2537e8c2cb68617f0ec84aaf7635ca",
        ),
        "linux_s390x": (
            "go1.15.14.linux-s390x.tar.gz",
            "cfe577ab8f7d779e45b2cb3a93062f7e5552e509d6e0c3e389bbfd6001ee4fe4",
        ),
        "windows_386": (
            "go1.15.14.windows-386.zip",
            "2a920a672986599dd91cb8ed6a2e07ee4038495f1f5daca9a202fb1b05abae90",
        ),
        "windows_amd64": (
            "go1.15.14.windows-amd64.zip",
            "88a77bebdd7276d0204f35e371aeaeb619f26b85d2ecf16f65cc713f4d49b9f7",
        ),
    },
    "1.15.13": {
        "darwin_amd64": (
            "go1.15.13.darwin-amd64.tar.gz",
            "fc5415935430f75316374c918a20067d7a1883e4b0ffb33dc8c2ff34df6d55fe",
        ),
        "freebsd_386": (
            "go1.15.13.freebsd-386.tar.gz",
            "d99f07567dc97166d5a7f9f857a64e4bf3641c02bc55e8ea5e24c7d4ca6f21a7",
        ),
        "freebsd_amd64": (
            "go1.15.13.freebsd-amd64.tar.gz",
            "36f451d50785ebca3aa1945bdfa475ec82c58dcadb84d4f9f969fccc53588071",
        ),
        "linux_386": (
            "go1.15.13.linux-386.tar.gz",
            "8df80ccbbd57b108ec43066925bf02aac47bc9e0236894dbd019f26944d27399",
        ),
        "linux_amd64": (
            "go1.15.13.linux-amd64.tar.gz",
            "3d3beec5fc66659018e09f40abb7274b10794229ba7c1e8bdb7d8ca77b656a13",
        ),
        "linux_arm64": (
            "go1.15.13.linux-arm64.tar.gz",
            "f3989dca4dea5fbadfec253d7c24e4111773b203e677abb1f01e768a99cc14e6",
        ),
        "linux_arm": (
            "go1.15.13.linux-armv6l.tar.gz",
            "00ff453f102c67ff6b790ba0cb10cecf73c8e8bbd9d913e5978ac8cc6323132f",
        ),
        "linux_ppc64le": (
            "go1.15.13.linux-ppc64le.tar.gz",
            "1a27f62d8812c28700e49cae46b9a378410e9eb735c79b1722cbe685f1c72528",
        ),
        "linux_s390x": (
            "go1.15.13.linux-s390x.tar.gz",
            "4448244965699706eff54d1f38917b8a896a27cf61a494f514818303c669a4b3",
        ),
        "windows_386": (
            "go1.15.13.windows-386.zip",
            "f6e7061495f43a6f26164d9430759a47382765fbf71c90ea714e275c9f4e99dc",
        ),
        "windows_amd64": (
            "go1.15.13.windows-amd64.zip",
            "d1cf76a11bbd5158715a3e3b6b7f0c623f5472f7c0e654c858913b74b09e7e81",
        ),
    },
    "1.15.12": {
        "darwin_amd64": (
            "go1.15.12.darwin-amd64.tar.gz",
            "05062d111062a5475f6f637018b09dc907bb6815bb156c26ebccf8d47ee35e2c",
        ),
        "freebsd_386": (
            "go1.15.12.freebsd-386.tar.gz",
            "b8153343d1c52d65c86be70f3eed2756cc2e0048a419fd9510ae4b8b99773190",
        ),
        "freebsd_amd64": (
            "go1.15.12.freebsd-amd64.tar.gz",
            "a63cca04ca822041219149402cf7b23c7f2d6b5d213329c1bf90cf9af62079d1",
        ),
        "linux_386": (
            "go1.15.12.linux-386.tar.gz",
            "d186ccaa0080e301d35fa49a244877da6f08a1aeda3ed90438fee835538f7ece",
        ),
        "linux_amd64": (
            "go1.15.12.linux-amd64.tar.gz",
            "bbdb935699e0b24d90e2451346da76121b2412d30930eabcd80907c230d098b7",
        ),
        "linux_arm64": (
            "go1.15.12.linux-arm64.tar.gz",
            "bfc8f07945296e97c6d28c7999d86b5cab51c7a87eb2b22ca6781c41a6bb6f2d",
        ),
        "linux_arm": (
            "go1.15.12.linux-armv6l.tar.gz",
            "a10161e6f0389c45ecd810e114acaba967ea3a4def551fcbb0b1e270996103ed",
        ),
        "linux_ppc64le": (
            "go1.15.12.linux-ppc64le.tar.gz",
            "c94c105e4e985b5675aa434845cced73a64bb050a8a96fa0e9b17dbea3ac6684",
        ),
        "linux_s390x": (
            "go1.15.12.linux-s390x.tar.gz",
            "9f1daa296e44ec0ce6b648e4e6d63210584b6c1ae2e46c77c8030b77514e8a8e",
        ),
        "windows_386": (
            "go1.15.12.windows-386.zip",
            "c31043ab926ae9b5b4a051baa85d19cfa24dac3b8255736824ec3a87aa6c9cf4",
        ),
        "windows_amd64": (
            "go1.15.12.windows-amd64.zip",
            "313e5ebc59b497319c4c3f9560322fcc20f7bc3b4e47494afc3b2d63a42fb2a5",
        ),
    },
    "1.15.11": {
        "darwin_amd64": (
            "go1.15.11.darwin-amd64.tar.gz",
            "651c78408b2c047b7ccccb6b244c5de9eab927c87594ff6bd9540d43c9706671",
        ),
        "freebsd_386": (
            "go1.15.11.freebsd-386.tar.gz",
            "c9ac9e8e12b9a4639d8a164815d2ccab86f7c1534672c1d03933e7180d2ace5d",
        ),
        "freebsd_amd64": (
            "go1.15.11.freebsd-amd64.tar.gz",
            "38fb5516e86934dc385d1b06433692034f38ed38117e8017e211a0efe55ed44e",
        ),
        "linux_386": (
            "go1.15.11.linux-386.tar.gz",
            "2de51fc6873d8b688d7451cfc87443ef49404af98bbab9c8a36fb6c4bc95e4de",
        ),
        "linux_amd64": (
            "go1.15.11.linux-amd64.tar.gz",
            "8825b72d74b14e82b54ba3697813772eb94add3abf70f021b6bdebe193ed01ec",
        ),
        "linux_arm64": (
            "go1.15.11.linux-arm64.tar.gz",
            "bfc8f07945296e97c6d28c7999d86b5cab51c7a87eb2b22ca6781c41a6bb6f2d",
        ),
        "linux_arm": (
            "go1.15.11.linux-armv6l.tar.gz",
            "dba11ed018fc7b5774ca996c4bdb847f8f9535cdc4932eb09a43c390813af4c9",
        ),
        "linux_ppc64le": (
            "go1.15.11.linux-ppc64le.tar.gz",
            "4916ef0fc4c40db2dcc503a3473b325ed21d100cc77f1cc7e0a3aede19eec628",
        ),
        "linux_s390x": (
            "go1.15.11.linux-s390x.tar.gz",
            "2fb25504fa525e24dbba7e8e7fa2d91c42c66272dc176d5270dec77099124c75",
        ),
        "windows_386": (
            "go1.15.11.windows-386.zip",
            "b0a64a2a2dedefd1559acf866e393c8e00294dbde113875ee9d8cf3561886123",
        ),
        "windows_amd64": (
            "go1.15.11.windows-amd64.zip",
            "56f63de17cd739287de6d9f3cfdad3b781ad3e4a18aae20ece994ee97c1819fd",
        ),
    },
    "1.15.0-rc.2": {
        "darwin_amd64": (
            "go1.15rc2.darwin-amd64.tar.gz",
            "b07775d30e023c1570b1ba74892fc792834436c790fbb0dbb19ebaae9c155105",
        ),
        "freebsd_386": (
            "go1.15rc2.freebsd-386.tar.gz",
            "7d0fafd526c161242265103d674e4b77ec5dae95fe3a8853e45454633bed5022",
        ),
        "freebsd_amd64": (
            "go1.15rc2.freebsd-amd64.tar.gz",
            "1f021399526442de11034a8db1bb9ede793078217d3d104775cfe65940122f0e",
        ),
        "linux_386": (
            "go1.15rc2.linux-386.tar.gz",
            "9c1f1ed42bd5f776f3585e39e3ba165a9b8ac8fde45dafbb6e41e04bae44bb3d",
        ),
        "linux_amd64": (
            "go1.15rc2.linux-amd64.tar.gz",
            "f41a08f630f018bc5d9fd100bd9899516e4965356c78165157eb0eda9a17ac09",
        ),
        "linux_arm64": (
            "go1.15rc2.linux-arm64.tar.gz",
            "e3e2cd95df2491d3cd74af9f73235dbf031dd2ecaf1140ab2793756be87d915f",
        ),
        "linux_arm": (
            "go1.15rc2.linux-armv6l.tar.gz",
            "60d4d7723ef55d49bbf8326f37011f967048ae9167ef462ee4b9af311c4f3244",
        ),
        "linux_ppc64le": (
            "go1.15rc2.linux-ppc64le.tar.gz",
            "9eb1d694eaf5104bf80187b6a3c3f0201c598b095f23e8af2bbb19ca3fb12d21",
        ),
        "linux_s390x": (
            "go1.15rc2.linux-s390x.tar.gz",
            "272793157e27c5a09e216f61f6a84d70808a901b89cc69b9e8cd6f8e019be27a",
        ),
        "windows_386": (
            "go1.15rc2.windows-386.zip",
            "114cdaf6f17520047e3734017890bfd87bcf7bcf73524a396204a6cc42662a75",
        ),
        "windows_amd64": (
            "go1.15rc2.windows-amd64.zip",
            "50b6be4a0713cf121af47f17b45c442e7d82b945011d762724cbf11a96fe4f7c",
        ),
    },
    "1.15.0-rc.1": {
        "darwin_amd64": (
            "go1.15rc1.darwin-amd64.tar.gz",
            "0572e053ed5fd6e8d6ed24f62832b747d46787288e146e8ba99b574b6e0d67b0",
        ),
        "freebsd_386": (
            "go1.15rc1.freebsd-386.tar.gz",
            "479c98371fd29426378596fbc94f96bdc4ac4a9d2bcb4f1ddbc4c1d4edb09ab5",
        ),
        "freebsd_amd64": (
            "go1.15rc1.freebsd-amd64.tar.gz",
            "9b14badd4b8dc881c9a15c2493565107ec92e78a71a51c7251cc0c377f92c3f9",
        ),
        "linux_386": (
            "go1.15rc1.linux-386.tar.gz",
            "e8b09a03cf057fe68806c0d2954ab8d9ca3002558d8ce60a196b836dacb91f4b",
        ),
        "linux_amd64": (
            "go1.15rc1.linux-amd64.tar.gz",
            "ac092ebb92f88366786063e68a9531d5eccac51371f9becb128f064721731b2e",
        ),
        "linux_arm64": (
            "go1.15rc1.linux-arm64.tar.gz",
            "3baf4336d1bcf1c6707c6e2a402a31cbc87cbd9a63687c97c5149911fe0e5beb",
        ),
        "linux_arm": (
            "go1.15rc1.linux-armv6l.tar.gz",
            "d42df2b62fc7569931fb458952b518e1ee102294efcc4e28c54cce76a7f4cd8f",
        ),
        "linux_ppc64le": (
            "go1.15rc1.linux-ppc64le.tar.gz",
            "a8599883755d188d24a5012f72f99b3237c2f5223bc1f937b6f055456c1468e3",
        ),
        "linux_s390x": (
            "go1.15rc1.linux-s390x.tar.gz",
            "0a16994b1f988db12aa44aa9965ae4d07d067489c321e5f7445eb2be63fe2466",
        ),
        "windows_386": (
            "go1.15rc1.windows-386.zip",
            "2e5f90da04f2ba073501eeb7931b897c9d57c9f8e079ee77620c6b1e4f9a8bdf",
        ),
        "windows_amd64": (
            "go1.15rc1.windows-amd64.zip",
            "cc05edc8620ed280dc4540b28312fdd99019a2a14693b6cc9158a26b43e67df3",
        ),
    },
    "1.15.0-beta.1": {
        "darwin_amd64": (
            "go1.15beta1.darwin-amd64.tar.gz",
            "4ee49feb46169ef942097513b5e783ff0f3f276b1eacfc51083e6e453117bd7e",
        ),
        "freebsd_386": (
            "go1.15beta1.freebsd-386.tar.gz",
            "77bc3aae4abaa73b537435b6a497043929cf95d7dd17c289f6e1b55180285c94",
        ),
        "freebsd_amd64": (
            "go1.15beta1.freebsd-amd64.tar.gz",
            "e13dd8a3e5a04bc1a54b2b70f540fd5e4d77663948c14636e27cf8a8ecfccd7b",
        ),
        "linux_386": (
            "go1.15beta1.linux-386.tar.gz",
            "83d732a3961006e058f44c9672fde93dbea3d1c3d69e8807d135eeaf21fb80c8",
        ),
        "linux_amd64": (
            "go1.15beta1.linux-amd64.tar.gz",
            "11814b7475680a09720f3de32c66bca135289c8d528b2e1132b0ce56b3d9d6d7",
        ),
        "linux_arm64": (
            "go1.15beta1.linux-arm64.tar.gz",
            "2648b7d08fe74d0486ec82b3b539d15f3dd63bb34d79e7e57bebc3e5d06b5a38",
        ),
        "linux_arm": (
            "go1.15beta1.linux-armv6l.tar.gz",
            "d4da5c06097be8d14aeeb45bf8440a05c82e93e6de26063a147a31ed1d901ebc",
        ),
        "linux_ppc64le": (
            "go1.15beta1.linux-ppc64le.tar.gz",
            "33f7bed5ee9d4a0343dc90a5aa4ec7a1db755d0749b624618c15178fd8df4420",
        ),
        "linux_s390x": (
            "go1.15beta1.linux-s390x.tar.gz",
            "493b4449e68d0deba559e3f23f611310467e4c70d30b3605ff06852f14477457",
        ),
        "windows_386": (
            "go1.15beta1.windows-386.zip",
            "6ef5301bf03a298a023449835a941d53bf0830021d86aa52a5f892def6356b19",
        ),
        "windows_amd64": (
            "go1.15beta1.windows-amd64.zip",
            "072c7d6a059f76503a2533a20755dddbda58b5053c160cb900271bb039537f88",
        ),
    },
}
