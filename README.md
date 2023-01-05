# Car Master

## Installation

```
sudo apt install ruby-dev ruby-bundler make build-essential libsdl2-dev libavahi-compat-libdnssd-dev
bundle set --global ~/.vendor/bundle
bundle install
```

```
sudo apt install mosquitto-clients mosquitto
```

## Usage

```
bundle exec exe/cisserver
```

Note: A running MQTT server is required on localhost.

## Snipets

```
mosquitto_sub -t 'carinsitu/#' -v
```

## Compatibility matrix

| Feature          | CarNode version |
|------------------|-----------------|
| Discovery UDP    |           0.1.0 |
| Trim on steering |           0.2.0 |
| RSSI             |           0.3.0 |
| SmartAudio       |           0.4.0 |
| IR               |           0.4.1 |
| VTX Channel      |           0.5.0 |
| MDNS             |           0.6.0 |
| TCP              |           0.6.0 |
| EEPROM           |           0.9.0 |

## Frequency table

|                 Band Channel → |   1  |   2  |   3  |   4  |   5  |   6  |   7  |   8  |
|--------------------------------|------|------|------|------|------|------|------|------|
| Band A: Boscam A / TBS / RC305 | 5865 | 5845 | 5825 | 5805 | 5785 | 5765 | 5745 | 5725 |
| Band B: Boscam B               | 5733 | 5752 | 5771 | 5790 | 5809 | 5828 | 5847 | 5866 |
| Band E: Boscam E / DJI         | 5705 | 5685 | 5665 | 5645 | 5885 | 5905 | 5925 | 5945 |
| Band F: IRC NexWave / Fatshark | 5740 | 5760 | 5780 | 5800 | 5820 | 5840 | 5860 | 5880 |
| Band R: Raceband               | 5658 | 5695 | 5732 | 5769 | 5806 | 5843 | 5880 | 5917 |

VTX Channel ID is in [0...39] range:
 * 0 → Band A, channel 1
 * 1 → Band A, channel 2
 * …
 * 8 → Band B, channel 1
 * …
 * 32 → Band R, channel 1
 * …
 * 39 → Band R, channel 8
