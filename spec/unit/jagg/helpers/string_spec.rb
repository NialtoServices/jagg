describe String do
  context 'a string' do
    subject { 'Hello, World!' }
    let(:md5) { '65a8e27d8879283831b664bd8b7f0ad4' }

    it '.to_md5' do
      expect(subject.to_md5).to eq(md5)
    end
  end
end
