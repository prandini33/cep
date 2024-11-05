trigger AccountTrigger on Account (after insert, after update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : Trigger.new) {
            accountIds.add(acc.Id);
        }
        CEPUpdaterService.atualizarEndereco(accountIds);
    }
}
