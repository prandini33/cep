public class CEPService {
    public class CepResponse {
        public String cep;
        public String logradouro;
        public String complemento;
        public String unidade;
        public String bairro;
        public String localidade;
        public String uf;
        public String estado;
        public String regiao;
        public String ibge;
        public String gia;
        public String ddd;
        public String siafi;
    }

    public static CepResponse buscarEndereco(String cep) {
        // Configuração da chamada de API para ViaCEP
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return (CepResponse) JSON.deserialize(response.getBody(), CepResponse.class);
        } else {
            throw new CalloutException('Erro na consulta do CEP: ' + response.getStatusCode());
        }
    }
}
