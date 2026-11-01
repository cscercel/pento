defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs, user_scope) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_number(:unit_price, greater_than: 0.0)
    |> unique_constraint(:sku)
    |> put_change(:user_id, user_scope.user.id)
  end

  @doc false
  def decrease_price(product, amount, user_scope)
      when is_number(amount) and amount > 0 do
    new_price = product.unit_price - amount

    product
    |> change(unit_price: new_price)
    |> validate_number(:unit_price, greater_than: 0.0)
  end
end
