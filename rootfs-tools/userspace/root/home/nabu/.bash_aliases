# nabu specific bash aliases

# apt (if using Debian/Ubuntu base)
alias sau="sudo apt update"
alias saug="sudo apt upgrade"
alias sai="sudo apt install"
alias sar="sudo apt remove"

# fastboot
alias fbre="fastboot reboot"
alias fbgc="fastboot getvar current-slot"
alias fbsa="fastboot set_active a"
alias fbsb="fastboot set_active b"
alias fbfa="fastboot flash boot_a"
alias fbfb="fastboot flash boot_b"

# file system
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# misc
alias e="exit"