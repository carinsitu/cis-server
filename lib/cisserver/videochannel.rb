module CisServer
  module VideoChannel
    CHANNELS_FREQUENCY = [
      5865, 5845, 5825, 5805, 5785, 5765, 5745, 5725, # Band A: Boscam A / TBS / RC305
      5733, 5752, 5771, 5790, 5809, 5828, 5847, 5866, # Band B: Boscam B
      5705, 5685, 5665, 5645, 5885, 5905, 5925, 5945, # Band E: Boscam E / DJI
      5740, 5760, 5780, 5800, 5820, 5840, 5860, 5880, # Band F: IRC NexWave / Fatshark
      5658, 5695, 5732, 5769, 5806, 5843, 5880, 5917  # Band R: Raceband
    ].freeze
    BANDS = [
      'A: Boscam A / TBS / RC305',
      'B: Boscam B',
      'E: Boscam E / DJI',
      'F: IRC NexWave / Fatshark',
      'R: Raceband',
    ].freeze

    def self.describe(channel)
      {
        frequency: CHANNELS_FREQUENCY[channel],
        band: BANDS[channel / 8],
        band_channel: 1 + channel % 8,
      }
    end
  end
end
