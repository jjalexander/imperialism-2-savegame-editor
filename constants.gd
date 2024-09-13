extends Node

const HEADER_START := 0
const HEADER_LENGTH := 5
const HEADER := "IBMAa"
const SAVENAME_START := 12
const SAVENAME_MAX_LENGTH := 18
const PLAYER_COUNTRY_NUMBER := 6527
const PLAYER_COUNTRY_NAME_START := 6528
const PLAYER_COUNTRY_NAME_LENGTH := 12
const COUNTRY_NAMES_START := 6838
const COUNTRIES_COUNT := 22
var WORLD_DATA_START_MARKER := PackedByteArray([0x1A, 0x03, 0x00, 0x0C, 0x03])
const WORLD_SIZE := 6480
const TILE_DATA_LENGTH := 40
const CITY_DATA_LENGTH := 209
