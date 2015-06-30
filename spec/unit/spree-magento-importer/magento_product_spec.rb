require 'spec_helper'
require 'spree_magento_importer/magento_product'

module SpreeMagentoImporter
  describe MagentoProduct, :dummy_app, db: :isolate do
    context 'with a simple product' do
      let(:magento_product) do
        MagentoProduct.new(
          name: 'Name',
          type: 'simple',
          short_description: 'Short description',
          description: 'Description',
          sku: '1234',
          price: '15.9900',
          special_price: '10.9900'
        )
      end

      describe '#spree_product_params' do
        let(:available_on) { Time.now }

        it 'returns a hash of params' do
          allow(Time).to receive(:now).and_return available_on

          expect(magento_product.spree_product_params).to eq(
            available_on: available_on,
            name: 'Name',
            description: "Short description\n\nDescription",
            sku: '1234',
            msrp: '15.9900',
            price: '10.9900',
            shipping_category_id: 1
          )
        end
      end
    end

    context 'with a grouped product' do
      let(:magento_product) do
        MagentoProduct.new(
          name: 'Name',
          type: 'grouped'
        )
      end

      describe '.new' do
        it 'raises an ArgumentError' do
          expect { magento_product }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
