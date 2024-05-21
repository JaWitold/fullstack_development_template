<?php

namespace App\Entity;

use App\Repository\PointRepository;
use Doctrine\ORM\Mapping as ORM;
use OpenApi\Attributes as OA;
use Symfony\Component\Serializer\Attribute\Groups;

#[ORM\Entity(repositoryClass: PointRepository::class)]
#[OA\Schema(schema: 'Point', description: "DUPA", type: 'object')]
class Point
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    #[Groups(['list_point'])]
    private ?int $id = null;

    #[ORM\Column]
    #[OA\Property(type: 'float')]
    #[Groups(['show_point', 'list_point'])]
    private ?float $x = null;

    #[ORM\Column]
    #[OA\Property(type: 'float')]
    #[Groups(['show_point', 'list_point'])]
    private ?float $y = null;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getX(): ?float
    {
        return $this->x;
    }

    public function setX(float $x): static
    {
        $this->x = $x;

        return $this;
    }

    public function getY(): ?float
    {
        return $this->y;
    }

    public function setY(float $y): static
    {
        $this->y = $y;

        return $this;
    }
}
