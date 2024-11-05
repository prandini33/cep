public class CEPUpdaterService {
    @future(callout=true)
    public static void atualizarEndereco(Set<Id> accountIds) {
        List<Account> contas = [SELECT Id, BillingPostalCode FROM Account WHERE Id IN :accountIds];

        // Obtenha as configurações de campos do Custom Metadata Type CEP__mdt
        Map<String, String> fieldMappings = new Map<String, String>();
        for (CEP__mdt config : [SELECT Campos__c, CampoAtualizado__c, Active__c FROM CEP__mdt WHERE Active__c = TRUE]) {
            fieldMappings.put(config.Campos__c, config.CampoAtualizado__c);
        }

        for (Account conta : contas) {
            try {
                // Consultar o CEP
                CepService.CepResponse endereco = CepService.buscarEndereco(conta.BillingPostalCode);

                // Mapeamento explícito entre os campos do CepResponse e os nomes dos campos em Campos__c
                Map<String, Object> cepData = new Map<String, Object>{
                    'cep' => endereco.cep,
                    'logradouro' => endereco.logradouro,
                    'complemento' => endereco.complemento,
                    'unidade' => endereco.unidade,
                    'bairro' => endereco.bairro,
                    'localidade' => endereco.localidade,
                    'uf' => endereco.uf,
                    'estado' => endereco.estado,
                    'regiao' => endereco.regiao,
                    'ibge' => endereco.ibge,
                    'gia' => endereco.gia,
                    'ddd' => endereco.ddd,
                    'siafi' => endereco.siafi
                };

                // Atualizar os campos dinamicamente com base no mapeamento
                for (String fieldKey : fieldMappings.keySet()) {
                    String accountField = fieldMappings.get(fieldKey);

                    if (cepData.containsKey(fieldKey)) {
                        conta.put(accountField, cepData.get(fieldKey));
                    }
                }
            } catch (Exception e) {
                System.debug('Erro ao atualizar endereço: ' + e.getMessage());
            }
        }

        update contas;
    }
}
