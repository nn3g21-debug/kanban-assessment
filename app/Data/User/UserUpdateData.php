<?php

namespace App\Data\User;

use App\Enums\UserRoles;
use Spatie\LaravelData\Data;

class UserUpdateData extends Data
{
    public function __construct(
        public string $name,
        public string $email,
        public ?string $password = null,
        public UserRoles $role = UserRoles::MEMBER,
        
    ) {}
}
