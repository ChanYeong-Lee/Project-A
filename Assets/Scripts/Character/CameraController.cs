using Cinemachine;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public enum State { Character, Horse }
    public State state;

    private PlayerMove playerMove;
    private HorseMoveWithStateMachine horseMove;

    private CinemachineVirtualCamera vCam;

    [SerializeField] private float playerFov = 60.0f;
    [SerializeField] private float horseFov = 70.0f;
    [SerializeField] private float changeAmount = 20.0f;

    private float currentFov = 0.0f;

    private float playerCoefficient = 0.0f;
    private float horseCoefficient = 0.0f;
    private float fovChangeVelocity = 0.0f;
    private float threshHold = 0.1f;

    private void Awake()
    {
        vCam = GetComponent<CinemachineVirtualCamera>();
    }

    private void OnEnable()
    {
        currentFov = playerFov;
    }

    private void Start()
    {
        playerMove = FindObjectOfType<PlayerMove>();
        horseMove = FindObjectOfType<HorseMoveWithStateMachine>();
    }

    private void Update()
    {
        if (playerMove == null || horseMove == null) return;

        playerCoefficient = playerMove.Speed < 2.0f ? 0.0f : (playerMove.Speed - 2.0f) / 3.33f;
        horseCoefficient = horseMove.MoveSpeed < 2.0f ? 0.0f : (horseMove.MoveSpeed - 2.0f) / 3.0f;

        state = horseMove.enabled ? State.Horse : State.Character;
        
        switch (state)
        {
            case State.Character:
                currentFov = playerFov + changeAmount * playerCoefficient;
                break;
            case State.Horse:
                currentFov = horseFov + changeAmount * horseCoefficient;
                break;
        }

        if (vCam.m_Lens.FieldOfView < currentFov)
        {
            vCam.m_Lens.FieldOfView = Mathf.SmoothDamp(vCam.m_Lens.FieldOfView, currentFov, ref fovChangeVelocity, 2.0f);
        }
        else
        {
            vCam.m_Lens.FieldOfView = Mathf.SmoothDamp(vCam.m_Lens.FieldOfView, currentFov, ref fovChangeVelocity, 0.5f);
        }

        if (Mathf.Abs(vCam.m_Lens.FieldOfView - currentFov) < threshHold)
        {
            vCam.m_Lens.FieldOfView = currentFov;
        }
    }
    //private void LateUpdate()
    //{
    //    if (vCam.m_Lens.FieldOfView < currentFov)
    //    {
    //        vCam.m_Lens.FieldOfView = Mathf.SmoothDamp(vCam.m_Lens.FieldOfView, currentFov, ref fovChangeVelocity, 2.0f);
    //    }
    //    else
    //    {
    //        vCam.m_Lens.FieldOfView = Mathf.SmoothDamp(vCam.m_Lens.FieldOfView, currentFov, ref fovChangeVelocity, 0.5f);
    //    }

    //    if (Mathf.Abs(vCam.m_Lens.FieldOfView - currentFov) < threshHold)
    //    {
    //        vCam.m_Lens.FieldOfView = currentFov;
    //    }
    //}

}
