# Car Master

## Installation

```
sudo apt install libsdl2-dev
bundle install --path vendor/bundle
```

## Usage

```
bundle exec exe/cisserver
```

## Snipets

```
mosquitto_sub -t 'carinsitu/#' -v
```

## Compatibility matrix

| Feature          | CarNode version |
|------------------|-----------------|
| Dicovery         |           0.1.0 |
| Trim on steering |           0.2.0 |
| RSSI             |           0.3.0 |
| SmartAudio       |           0.4.0 |
| IR               |           0.4.0 |
