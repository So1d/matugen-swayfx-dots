# --- Configuração do wl-gammarelay ---

#espera 1 sec
sleep 1

# 1. Inicia o serviço principal em segundo plano
killall wl-gammarelay-rs
wl-gammarelay-rs &

# 2. Define o gama (1.2) e a temperatura (5500K) para o monitor eDP-1.
busctl --user set-property rs.wl-gammarelay /outputs/eDP_1 rs.wl.gammarelay Gamma d 1.1

busctl --user set-property rs.wl-gammarelay /outputs/eDP_1 rs.wl.gammarelay Temperature q 5700
