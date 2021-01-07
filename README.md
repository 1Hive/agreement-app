# Agreement

Aragon Agreements allow organization actions to be governed by a subjective set of rules, that cannot be encoded into smart contracts.

Agreements are the bridge between an Aragon organization and Aragon Court. Organizations with an Agreement can become optimistic: most actions should be easily executed and challenged exceptionally, instead of forcing each user to go through a tedious approval process every time they want to perform an action.

#### 🛠️ Project stage: development

The Agreement app is still in development phase and aspects of the mechanism are still being designed and implemented.

#### ⚠️ Security review status: pre-audit

The code in this sub-repo is under heavy development and hasn't undergone a professional security review yet, therefore we cannot recommend using any of the code at the moment.

#### Note on calling permissioned functions from Disputable Voting
Disputable Voting blacklists the Agreement contract from being called in order to prevent votes from closing actions on the Agreements app that is shouldn't.
In order to call permissioned functions on the Agreement via vote, a separate contract that hard codes the call will need to be created which, in a single vote, can be granted the appropriate permission, called and have the permission removed.
