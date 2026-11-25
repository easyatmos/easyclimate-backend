import numpy as np
import xarray as xr

from . import _s2h


def sigma_to_hybrid_np(dati, hya, hyb, p0, sigi, intyp, psfc):
    return np.asarray(
        _s2h.dh2sdrv(
            dati=np.asarray(dati, dtype=np.float64),
            hya=np.asarray(hya, dtype=np.float64),
            hyb=np.asarray(hyb, dtype=np.float64),
            p0=np.float64(p0),
            sigi=np.asarray(sigi, dtype=np.float64),
            intyp=np.int32(intyp),
            psfc=np.float64(psfc),
        ),
        dtype=np.float64,
    )


def sigma_to_hybrid(
    dati: xr.DataArray,
    hya: xr.DataArray,
    hyb: xr.DataArray,
    p0: float,
    sigi: xr.DataArray,
    intyp: int = 2,
    psfc: xr.DataArray | float = 100000.0,
    input_lev_dim: str = "lev_in",
    output_lev_dim: str = "lev_out",
) -> xr.DataArray:
    dati, psfc = xr.broadcast(dati, psfc)

    return xr.apply_ufunc(
        sigma_to_hybrid_np,
        dati,
        hya,
        hyb,
        p0,
        sigi,
        intyp,
        psfc,
        input_core_dims=[
            [input_lev_dim],
            [output_lev_dim],
            [output_lev_dim],
            [],
            [input_lev_dim],
            [],
            [],
        ],
        output_core_dims=[[output_lev_dim]],
        vectorize=True,
        dask="parallelized",
        output_dtypes=[np.float64],
    )
