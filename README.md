# Agreement

Aragon Agreements allow organization actions to be governed by a subjective set of rules, that cannot be encoded into smart contracts.

Agreements are the bridge between an Aragon organization and Aragon Court. Organizations with an Agreement can become optimistic: most actions should be easily executed and challenged exceptionally, instead of forcing each user to go through a tedious approval process every time they want to perform an action.

#### 🛠️ Project stage: complete

The Agreement app's functionality is not expected to change in the near future.

#### ⚠️ Security review status: audited

The code in this repo has undergone a professional security review.

#### Note on calling permissioned functions from Disputable Voting
Disputable Voting blacklists the Agreement contract from being called in order to prevent votes from closing actions on the Agreements app that is shouldn't.
In order to call permissioned functions on the Agreement via vote, a separate contract that hard codes the call will need to be created which, in a single vote, can be granted the appropriate permission, called and have the permission removed.
