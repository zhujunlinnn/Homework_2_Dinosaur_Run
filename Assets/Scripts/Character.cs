using UnityEngine;

public class Character : MonoBehaviour
{
    public float moveForce = 5f;      // Movement force
    public float jumpForce = 5f;      // Jumping force
    private Rigidbody rb;
    private bool isGrounded = true;   // Whether the ball is on the ground

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        // --- Movement on the XZ plane ---
        if (Input.GetKey(KeyCode.W))
        {
            rb.AddForce(Vector3.forward * moveForce);
        }

        if (Input.GetKey(KeyCode.S))
        {
            rb.AddForce(Vector3.back * moveForce);
        }

        if (Input.GetKey(KeyCode.A))
        {
            rb.AddForce(Vector3.left * moveForce);
        }

        if (Input.GetKey(KeyCode.D))
        {
            rb.AddForce(Vector3.right * moveForce);
        }

        // --- Jump ---
        if (Input.GetKeyDown(KeyCode.Space) && isGrounded)
        {
            rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
            isGrounded = false;
        }
    }

    // --- Detect if the ball is on the ground ---
    private void OnCollisionEnter(Collision collision)
    {
        // When the ball touches an object with the "Ground" tag, it¡¯s considered grounded
        if (collision.gameObject.CompareTag("Ground"))
        {
            isGrounded = true;
        }
    }
}