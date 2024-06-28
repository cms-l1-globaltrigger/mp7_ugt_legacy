cd
rm -rf ~/mp7_ugt_legacy
git clone https://github.com/cms-l1-globaltrigger/mp7_ugt_legacy.git -b synth_work_flow ~/mp7_ugt_legacy
python3.9 -m venv env
. env/bin/activate
python3.9 ~/mp7_ugt_legacy/scripts/workflow_vhdl_prod_l1menu_commit.py $1 --repo $2
