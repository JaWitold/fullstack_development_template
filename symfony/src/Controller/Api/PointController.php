<?php

declare(strict_types=1);

namespace App\Controller\Api;


use App\Entity\Point;
use App\Form\PointType;
use App\Repository\PointRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use OpenApi\Attributes as OA;

#[Route('/api/point', name: 'api_point_')]
#[OA\Tag("Point")]
class PointController extends AbstractController
{

    public function __construct(private readonly SerializerInterface $serializer)
    {
    }

    #[Route('/', name: 'index', methods: [Request::METHOD_GET])]
    #[OA\Get(path: '/api/point', description: 'Get all the points', summary: 'List of points')]
    #[OA\Response(response: '200', description: 'The data')]

    public function index(PointRepository $pointRepository): Response
    {
        return new JsonResponse(
            $this->serializer->serialize($pointRepository->findAll(), JsonEncoder::FORMAT, [
                'groups' => ['list_point'],
            ]), Response::HTTP_OK, [], true
        );
    }

    #[Route('/new', name: 'new', methods: ['POST'])]
    public function new(Request $request, EntityManagerInterface $entityManager): Response
    {
        $point = new Point();
        $form = $this->createForm(PointType::class, $point);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $entityManager->persist($point);
            $entityManager->flush();
        }

        return $this->json([
            'point' => $point,
        ]);
    }

    #[Route('/{id}', name: 'show', methods: ['GET'])]
    public function show(Point $point): Response
    {
        return $this->json([
            'point' => $point,
        ]);
    }

    #[Route('/{id}', name: 'edit', methods: ['PUT'])]
    public function edit(Request $request, Point $point, EntityManagerInterface $entityManager): Response
    {
        $form = $this->createForm(PointType::class, $point);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $entityManager->flush();
        }

        return $this->json(['point' => $point]);
    }

    #[Route('/{id}', name: 'delete', methods: ['DELETE'])]
    public function delete(Request $request, Point $point, EntityManagerInterface $entityManager): Response
    {
        if ($this->isCsrfTokenValid('delete' . $point->getId(), $request->getPayload()->get('_token'))) {
            $entityManager->remove($point);
            $entityManager->flush();
        }

        return $this->json('ok');
    }
}
