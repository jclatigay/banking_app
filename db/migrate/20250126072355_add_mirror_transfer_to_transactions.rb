class AddMirrorTransferToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :mirror_transfer, :boolean
  end
end
