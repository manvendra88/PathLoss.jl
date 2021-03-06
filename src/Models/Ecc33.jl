@doc """ECC 33- Hata Extend
 freq: signal frequency(deve ser entre 500 e 1500Mhz)
 hb: base station's height
 hm: mobile's height
"""
type Ecc33Model<:Model
  freq::Float64
  txH::Float64
  rxH::Float64
  checkFreqRange::Bool
  Ecc33Model() = new(800,50,1.5,true)
end

@doc "Calculate Path loss for distance d (km) with ECC 33- Hata Extend "
function pathloss_op(model::Ecc33Model, d::AbstractFloat)
  #e 900 a 1900 MHz
  f = model.freq

  # Checking the frequency range
  if (model.checkFreqRange)
    if (f < 900 || f > 1900)
     error("The frequency range for Ecc-33 Model is 900MHz-1900Mhz")
    end
  end

  hb = model.txH
  hm= model.rxH
  PLfs = 92.4+20*log10(d)+20*log10(f/1000)
  PLbm = 20.41+9.83*log10(d)+7.894*(log10(f/1000))+9.56*(log10(f/1000))^2
  Gb = log10(hb/200)*(13.98+5.8*(log10(d))^2)
  Gm =(42.57+13.7*log10(f/1000))*(log10(hm)-0.585)
  PL= PLfs+PLbm-Gb-Gm
  return PL
end
